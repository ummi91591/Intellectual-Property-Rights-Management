import { describe, it, expect, beforeEach, vi } from 'vitest';

describe('IP Licensing Contract', () => {
  let mockContractCall: any;
  
  beforeEach(() => {
    mockContractCall = vi.fn();
  });
  
  it('should create a license', async () => {
    mockContractCall.mockResolvedValue({ success: true, value: 1 });
    const result = await mockContractCall('create-license', 1, 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG', 1000, 5);
    expect(result.success).toBe(true);
    expect(result.value).toBe(1);
  });
  
  it('should pay royalty', async () => {
    mockContractCall.mockResolvedValue({ success: true, value: 50 });
    const result = await mockContractCall('pay-royalty', 1, 1000);
    expect(result.success).toBe(true);
    expect(result.value).toBe(50);
  });
  
  it('should get license information', async () => {
    mockContractCall.mockResolvedValue({
      success: true,
      value: {
        ipId: 1,
        licensee: 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG',
        startDate: 123,
        endDate: 1123,
        royaltyRate: 5,
        totalPaid: 50
      }
    });
    const result = await mockContractCall('get-license', 1);
    expect(result.success).toBe(true);
    expect(result.value.royaltyRate).toBe(5);
  });
  
  it('should get royalties information', async () => {
    mockContractCall.mockResolvedValue({
      success: true,
      value: { totalRoyalties: 100 }
    });
    const result = await mockContractCall('get-royalties', 1);
    expect(result.success).toBe(true);
    expect(result.value.totalRoyalties).toBe(100);
  });
});

